class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "c5c604cca5bc0feeb5eccb1b12a69af843401fe9f92fb8130921f4af2d304ad7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db951c00ab72393079272ee6f57b5cedb45a0618a547a77e10e3d917ef9d7676"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e4bf3a7b1e442d1765c329110efbd859eacd0abb4d8e2fc8dc54a3d5d9432eb"
    sha256 cellar: :any,                 arm64_linux:   "0813709cb5c78122028d0dc782048dbfef7b61d3ce02009aa8742cae40f26ff8"
    sha256 cellar: :any,                 x86_64_linux:  "c4377940e046f3458c3ee89738bc2b29c3deed8aea8ae6c90c1f84a597d414a5"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    inreplace "Cargo.toml", /^version = ".*"$/, "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "zb_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zb --version")

    output = shell_output("#{bin}/zb --root #{testpath}/root --prefix #{testpath}/prefix init 2>&1")
    assert_match "Initialization complete!", output
    assert_path_exists testpath/"prefix/Cellar"
  end
end
