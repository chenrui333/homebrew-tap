class Certok < Formula
  desc "CLI to check the validity and expiration dates of SSL certificates"
  homepage "https://github.com/genuinetools/certok"
  url "https://github.com/genuinetools/certok/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "e874b7a04781ca5b056a53f3a7082ab91bd68e3841789e6d9aeab90ac5976149"
  license "MIT"

  livecheck do
    skip "no recent releases"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/genuinetools/certok/version.VERSION=#{version}
      -X github.com/genuinetools/certok/version.GITCOMMIT=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/certok version")

    hosts_file = testpath/"hosts.txt"
    hosts_file.write("example.com")
    output = shell_output("#{bin}/certok #{hosts_file}")
    assert_match "DigiCert Global G3 TLS ECC SHA384 2020 CA1  ECDSA-SHA384", output
  end
end
