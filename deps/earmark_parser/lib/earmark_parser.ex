defmodule EarmarkParser do


  @type ast_meta :: map()
  @type ast_tag :: binary()
  @type ast_attribute_name :: binary()
  @type ast_attribute_value :: binary()
  @type ast_attribute  :: {ast_attribute_name(), ast_attribute_value()}
  @type ast_attributes :: list(ast_attribute())
  @type ast_tuple :: {ast_tag(), ast_attributes(), ast(), ast_meta()}
  @type ast_node :: binary() | ast_tuple()
  @type ast :: list(ast_node())

  @moduledoc """

  ### API

  #### EarmarkParser.as_ast

  This is the structure of the result of `as_ast`.

      {:ok, ast, []}                   = EarmarkParser.as_ast(markdown)
      {:ok, ast, deprecation_messages} = EarmarkParser.as_ast(markdown)
      {:error, ast, error_messages}    = EarmarkParser.as_ast(markdown)

  For examples see the functiondoc below.

  #### Options

  Options can be passed into `as_ast/2` according to the documentation of `EarmarkParser.Options`.

      {status, ast, errors} = EarmarkParser.as_ast(markdown, options)

  ## Supports

  Standard [Gruber markdown][gruber].

  [gruber]: <http://daringfireball.net/projects/markdown/syntax>

  ## Extensions

  ### Github Flavored Markdown

  GFM is supported by default, however as GFM is a moving target and all GFM extension do not make sense in a general context, EarmarkParser does not support all of it, here is a list of what is supported:

  #### Strike Through

      iex(1)> EarmarkParser.as_ast("~~hello~~")
      {:ok, [{"p", [], [{"del", [], ["hello"], %{}}], %{}}], []}

  #### Syntax Highlighting

  All backquoted or fenced code blocks with a language string are rendered with the given
  language as a _class_ attribute of the _code_ tag.

  For example:

      iex(2)> [
      ...(2)>    "```elixir",
      ...(2)>    " @tag :hello",
      ...(2)>    "```"
      ...(2)> ] |> EarmarkParser.as_ast()
      {:ok, [{"pre", [], [{"code", [{"class", "elixir"}], [" @tag :hello"], %{}}], %{}}], []}

  will be rendered as shown in the doctest above.

  If you want to integrate with a syntax highlighter with different conventions you can add more classes by specifying prefixes that will be
  put before the language string.

  Prism.js for example needs a class `language-elixir`. In order to achieve that goal you can add `language-`
  as a `code_class_prefix` to `EarmarkParser.Options`.

  In the following example we want more than one additional class, so we add more prefixes.

      iex(3)> [
      ...(3)>    "```elixir",
      ...(3)>    " @tag :hello",
      ...(3)>    "```" 
      ...(3)> ] |> EarmarkParser.as_ast(%EarmarkParser.Options{code_class_prefix: "lang- language-"})
      {:ok, [{"pre", [], [{"code", [{"class", "elixir lang-elixir language-elixir"}], [" @tag :hello"], %{}}], %{}}], []}


  #### Tables

  Are supported as long as they are preceded by an empty line.

      State | Abbrev | Capital
      ----: | :----: | -------
      Texas | TX     | Austin
      Maine | ME     | Augusta

  Tables may have leading and trailing vertical bars on each line

      | State | Abbrev | Capital |
      | ----: | :----: | ------- |
      | Texas | TX     | Austin  |
      | Maine | ME     | Augusta |

  Tables need not have headers, in which case all column alignments
  default to left.

      | Texas | TX     | Austin  |
      | Maine | ME     | Augusta |

  Currently we assume there are always spaces around interior vertical unless
  there are exterior bars.

  However in order to be more GFM compatible the `gfm_tables: true` option
  can be used to interpret only interior vertical bars as a table if a seperation
  line is given, therefor

       Language|Rating
       --------|------
       Elixir  | awesome

  is a table (iff `gfm_tables: true`) while

       Language|Rating
       Elixir  | awesome

  never is.

  #### HTML Blocks

  HTML is not parsed recursively or detected in all conditons right now, though GFM compliance
  is a goal.

  But for now the following holds:

  A HTML Block defined by a tag starting a line and the same tag starting a different line is parsed
  as one HTML AST node, marked with %{verbatim: true}

  E.g.

        iex(4)> lines = [ "<div><span>", "some</span><text>", "</div>more text" ]
        ...(4)> EarmarkParser.as_ast(lines)
        {:ok, [{"div", [], ["<span>", "some</span><text>"], %{verbatim: true}}, "more text"], []}

  And a line starting with an opening tag and ending with the corresponding closing tag is parsed in similar
  fashion

        iex(5)> EarmarkParser.as_ast(["<span class=\\"superspan\\">spaniel</span>"])
        {:ok, [{"span", [{"class", "superspan"}], ["spaniel"], %{verbatim: true}}], []}

  What is HTML?

  We differ from strict GFM by allowing **all** tags not only HTML5 tagsn this holds for oneliners....

        iex(6)> {:ok, ast, []} = EarmarkParser.as_ast(["<stupid />", "<not>better</not>"])
        ...(6)> ast
        [
          {"stupid", [], [], %{verbatim: true}},
          {"not", [], ["better"], %{verbatim: true}}]

  and for multiline blocks

        iex(7)> {:ok, ast, []} = EarmarkParser.as_ast([ "<hello>", "world", "</hello>"])
        ...(7)> ast
        [{"hello", [], ["world"], %{verbatim: true}}]

  #### HTML Comments

  Are recoginized if they start a line (after ws and are parsed until the next `-->` is found
  all text after the next '-->' is ignored

  E.g.

      iex(8)> EarmarkParser.as_ast(" <!-- Comment\\ncomment line\\ncomment --> text -->\\nafter")
      {:ok, [{:comment, [], [" Comment", "comment line", "comment "], %{comment: true}}, {"p", [], ["after"], %{}}], []}



  ### Adding Attributes with the IAL extension

  #### To block elements

  HTML attributes can be added to any block-level element. We use
  the Kramdown syntax: add the line `{:` _attrs_ `}` following the block.

  _attrs_ can be one or more of:

    * `.className`
    * `#id`
    * name=value, name="value", or name='value'

  For example:

      # Warning
      {: .red}

      Do not turn off the engine
      if you are at altitude.
      {: .boxed #warning spellcheck="true"}

  #### To links or images

  It is possible to add IAL attributes to generated links or images in the following
  format.

      iex(9)> markdown = "[link](url) {: .classy}"
      ...(9)> EarmarkParser.as_ast(markdown)
      { :ok, [{"p", [], [{"a", [{"class", "classy"}, {"href", "url"}], ["link"], %{}}], %{}}], []}

  For both cases, malformed attributes are ignored and warnings are issued.

      iex(10)> [ "Some text", "{:hello}" ] |> Enum.join("\\n") |> EarmarkParser.as_ast()
      {:error, [{"p", [], ["Some text"], %{}}], [{:warning, 2,"Illegal attributes [\\"hello\\"] ignored in IAL"}]}

  It is possible to escape the IAL in both forms if necessary

      iex(11)> markdown = "[link](url)\\\\{: .classy}"
      ...(11)> EarmarkParser.as_ast(markdown)
      {:ok, [{"p", [], [{"a", [{"href", "url"}], ["link"], %{}}, "{: .classy}"], %{}}], []}

  This of course is not necessary in code blocks or text lines
  containing an IAL-like string, as in the following example

      iex(12)> markdown = "hello {:world}"
      ...(12)> EarmarkParser.as_ast(markdown)
      {:ok, [{"p", [], ["hello {:world}"], %{}}], []}

  ## Limitations

    * Block-level HTML is correctly handled only if each HTML
      tag appears on its own line. So

          <div>
          <div>
          hello
          </div>
          </div>

    will work. However. the following won't

          <div>
          hello</div>

  * John Gruber's tests contain an ambiguity when it comes to
    lines that might be the start of a list inside paragraphs.

    One test says that

          This is the text
          * of a paragraph
          that I wrote

    is a single paragraph. The "*" is not significant. However, another
    test has

          *   A list item
              * an another

    and expects this to be a nested list. But, in reality, the second could just
    be the continuation of a paragraph.

    I've chosen always to use the second interpretation—a line that looks like
    a list item will always be a list item.

  * Rendering of block and inline elements.

    Block or void HTML elements that are at the absolute beginning of a line end
    the preceding paragraph.

    Thusly

          mypara
          <hr />

    Becomes

          <p>mypara</p>
          <hr />

    While

          mypara
           <hr />

    will be transformed into

          <p>mypara
           <hr /></p>

  ## Timeouts

  By default, that is if the `timeout` option is not set EarmarkParser uses parallel mapping as implemented in `EarmarkParser.pmap/2`,
  which uses `Task.await` with its default timeout of 5000ms.

  In rare cases that might not be enough.

  By indicating a longer `timeout` option in milliseconds EarmarkParser will use parallel mapping as implemented in `EarmarkParser.pmap/3`,
  which will pass `timeout` to `Task.await`.

  In both cases one can override the mapper function with either the `mapper` option (used if and only if `timeout` is nil) or the
  `mapper_with_timeout` function (used otherwise).

  """

  alias EarmarkParser.Error
  alias EarmarkParser.Options
  import EarmarkParser.Message, only: [sort_messages: 1]

  @doc """
        iex(13)> markdown = "My `code` is **best**"
        ...(13)> {:ok, ast, []} = EarmarkParser.as_ast(markdown)
        ...(13)> ast
        [{"p", [], ["My ", {"code", [{"class", "inline"}], ["code"], %{}}, " is ", {"strong", [], ["best"], %{}}], %{}}]


        iex(14)> markdown = "```elixir\\nIO.puts 42\\n```"
        ...(14)> {:ok, ast, []} = EarmarkParser.as_ast(markdown, code_class_prefix: "lang-")
        ...(14)> ast
        [{"pre", [], [{"code", [{"class", "elixir lang-elixir"}], ["IO.puts 42"], %{}}], %{}}]

  **Rationale**:

  The AST is exposed in the spirit of [Floki's](https://hex.pm/packages/floki).
  """
  def as_ast(lines, options \\ %Options{})
  def as_ast(lines, %Options{}=options) do
    context = _as_ast(lines, options)
    messages = sort_messages(context)

    status =
      case Enum.any?(messages, fn {severity, _, _} ->
             severity == :error || severity == :warning
           end) do
        true -> :error
        _ -> :ok
      end

    {status, context.value, messages}
  end
  def as_ast(lines, options) when is_list(options) do
    as_ast(lines, struct(Options, options))
  end
  def as_ast(lines, options) when is_map(options) do
    as_ast(lines, struct(Options, options |> Map.delete(:__struct__) |> Enum.into([])))
  end

  defp _as_ast(lines, options) do
    {blocks, context} = EarmarkParser.Parser.parse_markdown(lines, options)
    EarmarkParser.AstRenderer.render(blocks, context)
  end

  @doc """
    Accesses current hex version of the `EarmarkParser` application. Convenience for
    `iex` usage.
  """
  def version() do
    with {:ok, version} = :application.get_key(:earmark_parser, :vsn),
      do: to_string(version)
  end

  @default_timeout_in_ms 5000
  @doc false
  def pmap(collection, func, timeout \\ @default_timeout_in_ms) do
    collection
    |> Enum.map(fn item -> Task.async(fn -> func.(item) end) end)
    |> Task.yield_many(timeout)
    |> Enum.map(&_join_pmap_results_or_raise(&1, timeout))
  end

  defp _join_pmap_results_or_raise(yield_tuples, timeout)
  defp _join_pmap_results_or_raise({_task, {:ok, result}}, _timeout), do: result

  defp _join_pmap_results_or_raise({task, {:error, reason}}, _timeout),
    do: raise(Error, "#{inspect(task)} has died with reason #{inspect(reason)}")

  defp _join_pmap_results_or_raise({task, nil}, timeout),
    do:
      raise(
        Error,
        "#{inspect(task)} has not responded within the set timeout of #{timeout}ms, consider increasing it"
      )
end

# SPDX-License-Identifier: Apache-2.0
