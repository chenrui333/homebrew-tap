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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fe494367c8ded0d473c4ecea89172aa8af6c70a59d793f250789d504ae93b45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d02eaae04f5967142ee8a8b0909da352ab631b96705255ec36dae658de8f42c1"
    sha256 cellar: :any_skip_relocation, ventura:       "6c13c0e47d691af082be4c5074b181aa7019a853cdbe1c422b11b69b0b039093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd68e18b595c4694df156b3c9fc8f0e287f07aa363ac0a486b7876441f43a918"
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
