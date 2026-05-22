class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.10.tar.gz"
  sha256 "504fe650400137e4e8acb81f387c4c2b33412124033d65626ee367f7f6261110"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac93bca87eccee9fbba4effe9766d63a4e0d706b03f52a2641d1bf48b46bc513"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50107d1dd449b9219c758de0fa6428b38387c4edb08c7ed94a544cb7b4732d2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dce1a8f5905a739341d9500d936665d27140020140ef4231356cbcb1313751f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd9ebbd881be9e07db96c328b282db73da43e8147c40af177ccafbd04eed374d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b50139649d5260de849e7e8caf396e464a4958026537ed55be214462fd93824"
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
