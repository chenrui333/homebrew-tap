class Tfsort < Formula
  desc "CLI to sort Terraform variables and outputs"
  homepage "https://github.com/AlexNabokikh/tfsort"
  url "https://github.com/AlexNabokikh/tfsort/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "0fb2952c52d1f13fbf2a939d5bdd80b6bea3943f94f587ca73b04c6a107ab7c3"
  license "Apache-2.0"
  head "https://github.com/AlexNabokikh/tfsort.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc0d600c40219d37582fede11a08d6640e721f71ee8bc277bd2ba59f3c722d34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67acde0d52cf19d347c1e8fdaf3d4b8c8f579ec08f5142efea629f558b2cb101"
    sha256 cellar: :any_skip_relocation, ventura:       "f1a497a4a233f29dbc7fdd1a3bb5372b31f6054cec7f82566faa214e262ed466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5c1ba8667adb309e50f6dc50b42ba5a61f78976684ae8aec590ccaea7510274"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    # install testdata
    pkgshare.install "tsort/testdata"
  end

  test do
    cp_r pkgshare/"testdata/.", testpath

    output = shell_output("#{bin}/tfsort invalid.tf 2>&1", 1)
    assert_match "file invalid.tf is not a valid Terraform file", output

    system bin/"tfsort", "valid.tofu"
    assert_equal (testpath/"expected.tofu").read, (testpath/"valid.tofu").read
  end
end
