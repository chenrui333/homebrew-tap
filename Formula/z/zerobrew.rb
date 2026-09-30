class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "adff039a5e932f16daf4e0eb143435c1fe7266544897d14c357b5db2793d3fff"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d4673a569f26dce19be2c6cdd6907fbcd12f766a9c4fa90491d42984b7160e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc766a9bf9a3b48e1ca35c951e2fea8a5dd302a880b793e3c67e07bec86216bd"
    sha256 cellar: :any,                 arm64_linux:   "609383a8f927cd96df5c7aee2d98f669b81096e047bcbd6bb19265ea75f28bbb"
    sha256 cellar: :any,                 x86_64_linux:  "66f9e6b74fee847ed13f073f492cdde644419887c250e742ee351adb26f494f2"
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
