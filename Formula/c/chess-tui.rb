class ChessTui < Formula
  desc "Play chess from your terminal"
  homepage "https://github.com/thomas-mauran/chess-tui"
  url "https://github.com/thomas-mauran/chess-tui/archive/refs/tags/2.7.1.tar.gz"
  sha256 "471b6280c8aa0979956b85d54dfd216855a47f8517a9a1d3e5286e4044adaac5"
  license "MIT"
  head "https://github.com/thomas-mauran/chess-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f16a7c40ce38dd4ef013a949cb2e289f3f29400d68c661cdb004db8a14d315d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e0de112298cc236244d4857452f826a5783329ae46b07854721bd7be6b62472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64781266c8491d3851948b1fe9762872861ceee3e4733dc2877fa0b4e34ac47c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "995ed72a27a517cacb8299caac2da77a3230693f47784c54511c8b2732f29114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7fe6750e97e3dfb359beb089bec90115e304c813277e7349c05ff940e8ea3e6"
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
