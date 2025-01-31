class Hcldump < Formula
  desc "Dump the HCL(v2) abstract syntax tree"
  homepage "https://github.com/magodo/hcldump"
  url "https://github.com/magodo/hcldump/archive/7207c007b46d72c8f90abf4eafe271307582aa1c.tar.gz"
  version "0.0.0"
  sha256 "dd58066f20000b68599c038e90479aca2bacd0700546050d7f6eaf030e51cd22"
  # no license
  head "https://github.com/magodo/hcldump.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5faf44f9fc4c5b5799fbd6afc4e3953b30c530727309dc8f187d9f989731129"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "305f323cd3a1ac8bcc59799500a919bed98e5ba4a535815b01b7c3581619d2b8"
    sha256 cellar: :any_skip_relocation, ventura:       "2cc350ebbaea9b90b4f7691ddf025169b39f33e74afad7fe6a7042f3ab9b23c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8e62781833b2ec892a3f58423f303447bdd013a9c71099a8233a6221575d1a4"
  end

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
