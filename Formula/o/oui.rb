class Oui < Formula
  desc "MAC Address CLI Toolkit"
  homepage "https://oui.is/"
  url "https://github.com/thatmattlove/oui/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "33d7aecf62b0b61e20801c298e60e4c59c564bae40367bf0b379b71d5f425a9a"
  license "BSD-3-Clause-Clear"
  head "https://github.com/thatmattlove/oui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "462656cc13a0ff541d8777c7afaca58cea8b4071f87bfe45e357ceb35ebeac20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e6db060b17a4f71ccc934e304199d78995da3f910859e10c13b401e4398d414"
    sha256 cellar: :any_skip_relocation, ventura:       "59cfd6657dd8c8a1214386159436bc18869124daa7dc04e613393f7f76755b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21ebf9d3050ca7f06397272dbe802342889da8955c14f7a490f1f5dd9bca1928"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oui --version")
    output = shell_output("#{bin}/oui convert F4:BD:9E:01:23:45")
    assert_match "{244,189,158,1,35,69}", output
  end
end
