class Mgmt < Formula
  desc "Next generation config management"
  homepage "https://github.com/purpleidea/mgmt"
  url "https://github.com/purpleidea/mgmt/archive/refs/tags/0.0.27.tar.gz"
  sha256 "47f9732161e320e1fcf61e48f843a66d8111ba5297bd221c8784bbf0853ae107"
  license "GPL-3.0-only"

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "augeas"
  depends_on "libvirt"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/purpleidea/mgmt/version.Version=#{version}")
  end

  service do
    run [opt_bin/"mgmt", "run"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/mgmt.log"
    error_log_path var/"log/mgmt-error.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mgmt --version")
  end
end
