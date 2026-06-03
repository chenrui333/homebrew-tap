class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "03560b37252df68124559e5389c9b1059e2c85503704caaf09153a218116f0b0"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3266e44700a6eae654572782398ddb9509f19a07c879b4c1ccda55ff92cb5535"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dad99bb31b749730746a49983292c5cf02ddb63c8cfc77dde5835b02a7114578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7435f581e287f3a026e21f9e39f0b8c16969ddbcd067ee3b7aa7a6b1c30b5dd"
    sha256 cellar: :any,                 arm64_linux:   "6ecee12a116cb23ed366b9a716ed2cdb6de1803fd1c230fa2ffac35ec8092b78"
    sha256 cellar: :any,                 x86_64_linux:  "7f727351c50a1801103c327e5ccb572e2255a34ab571e49f9a523f5b59ac50b6"
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
