class Hcldump < Formula
  desc "Dump the HCL(v2) abstract syntax tree"
  homepage "https://github.com/magodo/hcldump"
  url "https://github.com/magodo/hcldump/archive/7207c007b46d72c8f90abf4eafe271307582aa1c.tar.gz"
  version "0.0.0"
  sha256 "dd58066f20000b68599c038e90479aca2bacd0700546050d7f6eaf030e51cd22"
  # no license
  head "https://github.com/magodo/hcldump.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.hcl").write <<~HCL
        provider "aws" {
          region = "us-west-2"
      }
    HCL

    assert_match "*hcl.File", shell_output("#{bin}/hcldump #{testpath}/test.hcl")
  end
end
