class Tfsort < Formula
  desc "CLI to sort Terraform variables and outputs"
  homepage "https://github.com/AlexNabokikh/tfsort"
  url "https://github.com/AlexNabokikh/tfsort/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "0fb2952c52d1f13fbf2a939d5bdd80b6bea3943f94f587ca73b04c6a107ab7c3"
  license "Apache-2.0"
  head "https://github.com/AlexNabokikh/tfsort.git", branch: "master"

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
