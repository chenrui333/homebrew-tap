class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "11fb3b63ee90a383e7e710877eaa2538db866759c531ad610c3d5fee360281f1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aabe982d483e758b5aa1dcfcc9b0c509de57008903d1870146f3c53bec2a13f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c632e9a60090d133accde390390baa56b03602a88f53c3233b74b2adb708b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a206f66fa5d1409d522190bce771233de54350ad0a2cd8ff28fab34e402ac029"
    sha256 cellar: :any,                 arm64_linux:   "534c60f7fafa508b89580f6d7ff66d10f41d1efb80e1209f77b4410edc978655"
    sha256 cellar: :any,                 x86_64_linux:  "43812f01d0e6365e0cd74f97d4da76bfebaef09d4fb4a9ffc256eaa9bc240eb2"
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
