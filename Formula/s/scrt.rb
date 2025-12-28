class Scrt < Formula
  desc "Secret manager for developers, sysadmins, and devops"
  homepage "https://scrt.run/"
  url "https://github.com/loderunner/scrt/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "72ac4c594e8c89b43d679118d571f2726a86628b324b33486fba4331b1dc39de"
  license "Apache-2.0"
  head "https://github.com/loderunner/scrt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f15ff0de532e8d76120c86c18a5250f37365818613bfc418fb0af105cc5f9f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dba88e41b6091032fdf79f42eb439c98bc19bf91fa27ea7c2db33ded7e0003e6"
    sha256 cellar: :any_skip_relocation, ventura:       "d6f8764dbe8bcd1d7b958f040d6710a4406e8447a930dca8a986267e3219c4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eb6a8698e92a116649508d799f2a87f0d821cda8ab7fac413bd4c8cb2b5488b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    # upstream bug report, https://github.com/loderunner/scrt/issues/1048
    # generate_completions_from_executable(bin/"scrt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrt --version")

    output = shell_output("#{bin}/scrt init --storage=local --password=p4ssw0rd --local-path=store.scrt")
    assert_match "store initialized", output
    assert_path_exists testpath/"store.scrt"
  end
end
