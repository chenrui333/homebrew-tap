# framework: clap
class Cai < Formula
  desc "CLI tool for prompting LLMs"
  homepage "https://github.com/ad-si/cai"
  url "https://github.com/ad-si/cai/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "af2080ff5bdca09a26db9f6b809b5a480b24b75a833622832ca022e213fd5173"
  license "ISC"
  head "https://github.com/ad-si/cai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3144ec1a5be69c60a06df654669fd9f1baeb1db699cde8af0ed51cb721d29f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8b1e336f06fd024db3330258ea9756e463ba83c18e692de9a4a22eb431c6050"
    sha256 cellar: :any_skip_relocation, ventura:       "6a7aff1722fd52e28fe8d5bb25dc48786a9691fb7b551bbe992c96a9740e6db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12f631eb08bbea80111377477581252920f50972076f654ab61f61a9049b5639"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cai anthropic claude-opus Which year did the Titanic sink 2>&1", 1)
    assert_match "An API key must be provided", output

    output = shell_output("#{bin}/cai ollama llama3 Which year did the Titanic sink 2>&1", 1)
    assert_match "error sending request for url", output
  end
end
