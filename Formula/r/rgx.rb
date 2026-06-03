class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "03560b37252df68124559e5389c9b1059e2c85503704caaf09153a218116f0b0"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e40900dd90a69f55a746b19f8325283335083aa895f0457d03356f5febc6e5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39a1ea5c992d4d99bdc07e78e7aba5ee97541fd1442eeea14645d813ed66fa2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9293c05865639705a2eb9cbf83d958faf2613f5a7ad543a59ae659493f1617e"
    sha256 cellar: :any,                 arm64_linux:   "1893e5599192ce357f7f4a3c88669d1a5c68cf114d34d97ffc4c9de3c33f12e0"
    sha256 cellar: :any,                 x86_64_linux:  "790d16adf92e2507fdb7cc48164189fd38e9cd0481aaa1b938ed638813b0bdf3"
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
