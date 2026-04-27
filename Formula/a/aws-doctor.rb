class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "859dad52e75791bad3e724a2d1e81ab801d79508d2d1a461effa613c6c3e12d5"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b88dd84264741e7eeecedc03823a18fdbf395f1432fd651cfa824939c8f757a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b88dd84264741e7eeecedc03823a18fdbf395f1432fd651cfa824939c8f757a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b88dd84264741e7eeecedc03823a18fdbf395f1432fd651cfa824939c8f757a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82c336cf39eda680bdfcf97c1ec92fd0a5e627d2357e854b4a1639c9a417b1b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "197c281e573342156169486fa3d241547079bb28397da5e5c09415d1f97bd63a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-doctor version")
    output = shell_output("#{bin}/aws-doctor --invalid-flag 2>&1", 1)
    assert_match "unknown flag", output
  end
end
