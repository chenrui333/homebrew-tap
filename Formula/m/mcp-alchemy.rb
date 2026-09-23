class McpAlchemy < Formula
  include Language::Python::Virtualenv

  desc "MCP server that connects to your database"
  homepage "https://github.com/runekaagaard/mcp-alchemy"
  url "https://files.pythonhosted.org/packages/68/13/5663bf20004b283a7d063d452156b7b1b6bc8bca11f3837e1877e9ea36c2/mcp_alchemy-2026.9.5.185701.tar.gz"
  sha256 "af8710d6d089d82d3ab594dc536f1fd7bfb02f7318f60706b282992077ef18de"
  license "MPL-2.0"
  head "https://github.com/runekaagaard/mcp-alchemy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d12b89c7af97e3f12603c197c1eb61589c5afc7666bfcad05e65be6e9971cef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2e4c7c94c0e5e0f05c20a0dbf4d059336e17633b05a4b6bdad028f271330260"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "207f0bb71343a66d5ebc5669302599857c564882ffdd42402cce0c01bce79cd3"
    sha256 cellar: :any,                 arm64_linux:   "94de85736345808457821ab12f1e2a2d4d617fb49b768abdbb9f9957cc07352c"
    sha256 cellar: :any,                 x86_64_linux:  "441341799097f0d4dc71275e4e5c91222657b4c6a3a2f9a61682b2f4d3b75391"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[certifi cryptography pydantic rpds-py]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/15/8c/e925b1c92018abb3a1863ce1549d76d2381e334d21d65d4ac8f65dabd78a/httpcore2-2.13.0.tar.gz"
    sha256 "2adc8be4fb285fbcd6d894298db3b52c177e74b6674eda3a76bd36be3292a3db"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/b9/a0/e9deef4654132857b5a5dbe4eddd0ac59c2814500e11f2f5044cd81103ee/httpx2-2.13.0.tar.gz"
    sha256 "81bd07dc67a3701729ef1f777a3c00c915d4539604fdb5afd327f8682f6b7b44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/d4/6e/21fb8e5d579dbe21d96ea4d5034200d46d8bdf2261053b5bd041f3c2f612/mcp-2.1.1.tar.gz"
    sha256 "50b7ba1ebbe117008ea7bdd288234043e69c20b403d6851d19661e6d431a75ef"
  end

  resource "mcp-types" do
    url "https://files.pythonhosted.org/packages/6a/dd/1c4417dc0b722c23a1669032d5f044e41170fe5d4773b488a50fcce98c32/mcp_types-2.1.1.tar.gz"
    sha256 "77dcbe48fba73cca71a673f2646a5f037a017b7a0a07ac89cec1113028890eda"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/ee/8b/aa9e2d8b8dfa7c946f7dec5d1f8f6ba8eca062f43509a06bdb5ce93d26c0/opentelemetry_api-1.44.0.tar.gz"
    sha256 "67647e5e9566edcf421166fdf022b3537f818635daa852b289e34604dc6fb33a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/af/c3/8a3b59c25070cc61dc517fbdfa5dc0904670c96f605cc69759dc09166b99/pyjwt-2.14.0.tar.gz"
    sha256 "77283c83fb56ecf566a886c757a714bc83668e38156de2cce8263302f42e0b86"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/50/65/9cbc9c4c3287bed2499e05033e207473504dc4df999ce49385fb1f8b058a/sqlalchemy-2.0.36.tar.gz"
    sha256 "7f2767680b6d2398aea7082e45a774b2b0767b5c8d8ffb9c8b683088ea9b29c5"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/2b/54/6767bb789b2f2fed6e0f953df949cd39dc263a384c1b65a95232598621d6/sse_starlette-3.4.11.tar.gz"
    sha256 "1bae716c02f3e6f294be41ff333220692dae7c3cbab077c900f159676719dade"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/b5/b4/205b0d5241d934e8add0c38aa924c4f9fb7330834ff11e5444db964ec3f9/starlette-1.6.0.tar.gz"
    sha256 "d4e3ac5e546444960c710297a3c9fc3f7ebae1b7e963f3d36173b49da535be9b"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/16/f7/57713ba479fd405eb76de31404b2c744c289e336b2d999511ebf51e496f7/typer-0.27.2.tar.gz"
    sha256 "269b7eb9d3c202ca84b4bc9618cb04ebb43d3d4d1e567e4c768607232c05f945"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/5d/ad/04bbb797c84fc1f26cb171f7394716f4865ffb8d8c5e1eef42565c2dfa6b/uvicorn-0.53.0.tar.gz"
    sha256 "a9356f0cb89b3b8621529c5d5eebd69bfe154f4c3f68b4cf2de47e45fa855c2e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "json"
    require "open3"

    ENV["DB_URL"] = "sqlite:///#{testpath}/test.db"

    initialize_request = {
      jsonrpc: "2.0",
      id:      1,
      method:  "initialize",
      params:  {
        protocolVersion: "2025-03-26",
        capabilities:    {},
        clientInfo:      { name: "homebrew-test", version: "1.0.0" },
      },
    }.to_json
    initialized_notification = { jsonrpc: "2.0", method: "notifications/initialized", params: {} }.to_json
    tools_request = { jsonrpc: "2.0", id: 2, method: "tools/list", params: {} }.to_json

    Open3.popen2e("#{bin}/mcp-alchemy") do |stdin, output, wait_thread|
      stdin.sync = true
      read_response = lambda do
        loop do
          line = output.gets
          raise "mcp-alchemy exited before responding" unless line

          begin
            break JSON.parse(line)
          rescue JSON::ParserError
            next
          end
        end
      end

      stdin.puts initialize_request
      initialize_response = read_response.call
      assert_equal version.to_s, initialize_response.dig("result", "serverInfo", "version")

      stdin.puts initialized_notification
      stdin.puts tools_request
      tools_response = read_response.call
      descriptions = tools_response.dig("result", "tools").map { |tool| tool["description"] }.join("\n")
      assert_match "Return all table names in the database separated by comma", descriptions

      stdin.close
      assert_predicate wait_thread.value, :success?
    end
  end
end
