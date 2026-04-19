class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "9affcf4a715cdd884133a04bb2b5db2b7114d4179d8abe18235fc42dbc42aa6f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a783b00916afd86c9f9e47b24380c86c5bed10b1d485573bfc1a018401ec2ce8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a61406127065cc73d807c15d36b0e202369ada39501fcc68e9cd7f1a38e50a05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc65ac2c21b300aa57924cd4a0e8e32f8a518e43a3ae9246208c8ff662de9648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4568d423d3eb0cae736e1171a45ab454d32bec502a2f80287d86b7a20b81465e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee72730f997b407f33e0ea389b223a81602bcef7c6c83171c0ad1f6be3bca478"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
    generate_completions_from_executable(bin/"rgx", "--completions")
  end

  test do
    assert_equal "42\n99\n", shell_output("#{bin}/rgx -p -t 'hello 42 world 99' '\\d+'")
    assert_equal "3\n", shell_output("#{bin}/rgx -p -c -t 'a1 b2 c3' '\\d+'")
  end
end
