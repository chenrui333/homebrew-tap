class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.22.0.tar.gz"
  sha256 "03d502cdefce93498d39474edff25ab7a06ddb0bb6ce0a4828d8416c47a72e82"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3795b4a2dee59e647da53ea9debdc1bfcb74c9760f33ff9dec257cff940d8ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de99918f1aab00a37a92562a435205fc6841ceee2eed569271be194eee3944e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2daea8024b792fe613faac5fdf2829656308dd558f6c3199684f209753865f2"
    sha256 cellar: :any,                 arm64_linux:   "b7c0ef63783c2b3a8d4651ca19ea5d22463ee89ce32a76f042b9834146b69f21"
    sha256 cellar: :any,                 x86_64_linux:  "f870683a494280a6a177a458e88bfd5a99fd17461ff868897da5731251479085"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
