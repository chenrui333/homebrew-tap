class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "7b2a50dd5eac1993be8d34079797869675440651c511216682c46ef74ecf0687"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7aa5acd787c505cb4bb09758c0a4dbf2df472a679eade0b60859a2917cb36c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed98c5e2fbefad8f9288372f1c24a0a8d4f95745b63fdb0b8b7ea681db0c8e43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "604f64389fb5d577997f813b2679cd28c0eaad7b7227a4d57d8453b67b8ed010"
    sha256 cellar: :any,                 arm64_linux:   "52d9474d008b0a619cb9ecfb915785e8b14bc2118515655b54b8c488c9dafe9c"
    sha256 cellar: :any,                 x86_64_linux:  "75be5e7f112dc38909fe84ff7b5e01dd3d4485dec99b962ed2106dddab04ad64"
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
