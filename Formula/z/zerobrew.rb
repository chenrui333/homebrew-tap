class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "5e80d400b49593a68e1dc9b43821fe7800b038ef7064bebf4f4fc2bf9e174c60"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfc23f72cac8a58f02b1d6e1377bfe243570d8c257e7149da730a8e1e531db56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "288fe093440b49e6ba173ce5b428157954d0d5f059d820829001f8aa7330bc82"
    sha256 cellar: :any,                 arm64_linux:   "5452e387e830135bbfdf89f5f6375c1cef740e140de71be0cf15f967f5103997"
    sha256 cellar: :any,                 x86_64_linux:  "139d34b54aab0e390fe6048c88b9a5b6f727fc5fa73a39058167409677645084"
  end

  depends_on "rust" => :build

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
