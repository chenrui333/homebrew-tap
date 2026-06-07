class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "7b2a50dd5eac1993be8d34079797869675440651c511216682c46ef74ecf0687"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cc0b364d45b6d24cc396be2341926f395989cba597f09c3d71bcb19f52e4c6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f91a35d89259c256550925ff981dde1cd63c888d4a7d12c5a60c6d512690e9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b134dcbc0b55da9601c91cf4e72ebcd7616f3ec7ca6b034f0a33c173f46b7e7a"
    sha256 cellar: :any,                 arm64_linux:   "358e3cc6e3430a75f1a866cee48586860e1ee6d067260b15be25595834b0938c"
    sha256 cellar: :any,                 x86_64_linux:  "2973db44aa3ce2b87d37601019e6a0a65a8800b4d438d9a0b7ac4c3e436c08c3"
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
