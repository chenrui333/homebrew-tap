class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.14.1.tar.gz"
  sha256 "ace164845739fe2f8101a1d81d396225289dbf76b65b8b111164f416dacc5016"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27adcf95f517071e9363805f53d6d11a6de9bd8a48071bd8f0f5f84c90d68916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cba4633fa289e1f94ef8c91b8d2789c36e01a843e9353038b6370683460887f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b84829888cb4a36dbd09229d0730851da979801491f512c678f6d158758b7bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd01ef20f4c376496c9c95e4fd110be89bef22d48c8b7ec41435e66a5ad471b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a99d033bc83e19c6ed01398e595b291c54c304e37b72b4d5afbb59b7b91f8286"
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
