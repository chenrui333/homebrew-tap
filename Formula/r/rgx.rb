class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "0b3f7db478d5b3c83e3e51c671b42d339fa48dc23d94d2ef0e87f51dd6c98b9d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c95b9a8b04b6cfa3b9136b64370eb120e2f92eb7084c9290e7de34ab445198a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8e99d3f57e970b6fa232ea8d4e04dd06e31b08734a01a8aede0db18c269c406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6d79bbfd35f9da2a77b601445fbb979097c58b447a6ad39bac5586830863766"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a22a8fcc52212ab5e9ec3693fb989b00124a64255694f650051e56d414ec893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7bec50cd6be9f55bfc9cb9144caaec2bfc94c9d41115690768e0c62171e98ce"
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
