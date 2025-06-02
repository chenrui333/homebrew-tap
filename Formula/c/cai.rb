# framework: clap
class Cai < Formula
  desc "CLI tool for prompting LLMs"
  homepage "https://github.com/ad-si/cai"
  url "https://github.com/ad-si/cai/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "e4fcd76172ddd8fb95cbb81583bc836fe8ac2ef9c41feaec3dbb32697b7b4b27"
  license "ISC"
  head "https://github.com/ad-si/cai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ceb7cbb4c566e10a3cb4aca6e979de9e3eaf9541dc911c172cd90b9c136bb70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aca2ba31c0d7047d89b23b891ff6f7112597cfaf51b81949a5848a0a85ec69a5"
    sha256 cellar: :any_skip_relocation, ventura:       "bafbba1cc90ff636af05bcb74120209aa9e6066b78e4a5fae12feddf5adfa1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4f6e7b6ba00285f6662daebf9861cae63028dc13193197a43b10912f8632c3e"
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
