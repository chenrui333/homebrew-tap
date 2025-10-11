class Terrafetch < Formula
  desc "Neofetch of Terraform. Let your IaC flex for you"
  homepage "https://github.com/RoseSecurity/terrafetch"
  url "https://github.com/RoseSecurity/terrafetch/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "d9daffc04c9996c5901444917d76806cf1e7e6933a32139f1d6452d08ef787a7"
  license "Apache-2.0"
  revision 1
  head "https://github.com/RoseSecurity/terrafetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac2a8c14f43682398f8131da99a882746704c2d6179ab8f40ae1ad961e35b52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "017ff5ea8707c7dbc030673e77ca3e5768c5b37b3f327e2a2fdb89a785ddef0a"
    sha256 cellar: :any_skip_relocation, ventura:       "0dcc37fa243dcafbe5cda5690239cef222bc6c00d52e8b51ffb134c8ab57cd02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de3976d43c4f921e6ecdc6d2ef4fb7f1b25b9a6306d7d98fac434e54259a0dc5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"main.tf").write <<~TF
      terraform {
        required_version = ">= 0.12"
      }

      # one resource
      resource "null_resource" "r1" {}
    TF

    assert_match "Terraform Files:     1", shell_output("#{bin}/terrafetch -d .")
  end
end
