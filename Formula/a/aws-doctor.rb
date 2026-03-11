class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "e651ce91b7ab74117fc4154b8ae88b43c5feea6569ad3ab39907dd3a52b4afb4"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bf886dbf534d9659dd1bd9bea4dbf53779b0497158c371e7ce8c709bc96d6ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bf886dbf534d9659dd1bd9bea4dbf53779b0497158c371e7ce8c709bc96d6ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bf886dbf534d9659dd1bd9bea4dbf53779b0497158c371e7ce8c709bc96d6ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be9abf5415b2648ed8fdb60928f8870bd0fc10178ca2cd30f6b03bf4f141c305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7206e300741f35d8033363a87aeeab8b0786971a5b796f48e2786579fdcfda06"
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
    assert_match version.to_s, shell_output("#{bin}/aws-doctor --version")
    output = shell_output("#{bin}/aws-doctor --invalid-flag 2>&1", 1)
    assert_match "flag provided but not defined", output
  end
end
