class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.7.tar.gz"
  sha256 "2715dec629df9ff59f43a2efbf7b4d57776d73c512fdcc91b2cc90efbaf8fd52"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfab899d4aa49aaa2d5d9b2f63108c1830adcb9420f96318446da0a3a455af63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "090c5a9d71efee0b381ecff9d249cbdd395a851a1694f9017d0ff8c97df023e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92807e161b24477c5c2cc124c6bc262fef1f8bf32da88d9eab32da242073c439"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59e04cfbc306380bc081006bb86b34ba904524d70e19a60f5b97be5ac97aade0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "731e8eb157b44646c92a5ec09da8239ce59b4bac77d72131c34b89492ea71973"
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
