class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "d1c4c814f702802a4acd94a5131797d09ff0ba065c746411d65237823bcc1374"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9d4d4825c02b61faba8fc54e6214717685518127033e3a15cf82c01e12215c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17098c2746291775d14f90396434ea0890cb5162d7d414224fe007ebdcb375c1"
    sha256 cellar: :any_skip_relocation, ventura:       "49f03c659a489438f09e8cc745091272ac18f119d18f81ab9872b44fda5b2a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef4a93ee243e6c5a9210c210e002e4da6282d69c64dbf73a26fe4d4de2d43d22"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/ytt/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ytt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ytt --version")

    (testpath/"values.lib.yml").write <<~YAML
      #@ def func1():
      name: max
      cities:
      - SF
      - LA
      #@ end

      #@ def func2():
      name: joanna
      cities:
      - SF
      #@ end
    YAML

    (testpath/"template.yml").write <<~YAML
      #! YAML library files must be named *.lib.yml
      #@ load("values.lib.yml", "func1", "func2")

      func1_key: #@ func1()
      func2_key: #@ func2()
    YAML

    assert_match <<~YAML, shell_output("#{bin}/ytt -f values.lib.yml -f template.yml")
      func1_key:
        name: max
        cities:
        - SF
        - LA
    YAML
  end
end
