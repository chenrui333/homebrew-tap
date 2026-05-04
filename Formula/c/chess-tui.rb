class ChessTui < Formula
  desc "Play chess from your terminal"
  homepage "https://github.com/thomas-mauran/chess-tui"
  url "https://github.com/thomas-mauran/chess-tui/archive/refs/tags/2.6.2.tar.gz"
  sha256 "414a2b03751864cef59e7e3bd6fd8c9568a876a57d4b8605eaeeee1dec3cc625"
  license "MIT"
  head "https://github.com/thomas-mauran/chess-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed7c0187c469ddb560227660c3fea7bef992e6cf20ad4c3f9d45e5438f126284"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f428e3376ab394274902fd9fe4ea1903dc01f9ac444c0476ac2463b26474afcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e233e2d11d8c728b3e34e5b29573e6710b63b2e39cd586690027d33eea09fef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8c94e73ac4af7d61fe203d733e1f67650d705fda8afdea609f66dff7b06330b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f760a1d5f8f25f8690ca594598dcab827baefee561fc823e81d0e886cfa0853a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chess-tui --version")

    output = shell_output("#{bin}/chess-tui --update-skins")
    assert_match "Created skins.json with default content", output

    config_root = if OS.mac?
      testpath/"Library/Application Support"
    else
      testpath/".config"
    end
    assert_path_exists config_root/"chess-tui/skins.json"
  end
end
