class Sato < Formula
  desc "Tool to convert ARM or CFN into Terraform"
  homepage "https://github.com/JamesWoolfenden/sato"
  url "https://github.com/JamesWoolfenden/sato/archive/refs/tags/v0.1.32.tar.gz"
  sha256 "667d288a66e12248ebcc6365d13e02a89af2281240ce73f5f852bc69be4239d1"
  license "Apache-2.0"
  head "https://github.com/JamesWoolfenden/sato.git", branch: "master"

  depends_on "go" => :build

  def install
    inreplace "src/version/version.go", "Version = \"9.9.9\"", "Version = \"#{version}\""
    system "go", "build", *std_go_args(ldflags: "-s -w")

    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sato --version")

    cp_r pkgshare/"examples/.", testpath
    system bin/"sato", "parse", "--file", testpath/"aws-vpc.template.yaml"
    assert_path_exists testpath/".sato/variables.tf"
    assert_path_exists testpath/".sato/data.tf"
  end
end
