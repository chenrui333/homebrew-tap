class Certok < Formula
  desc "CLI to check the validity and expiration dates of SSL certificates"
  homepage "https://github.com/genuinetools/certok"
  url "https://github.com/genuinetools/certok/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "e874b7a04781ca5b056a53f3a7082ab91bd68e3841789e6d9aeab90ac5976149"
  license "MIT"

  livecheck do
    skip "no recent releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83d4a29052d1c279e449ef42652a33a1f4d087a03d36997429c09b0c2e273105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ee72d6beca808ee3a263d49e95031b7c714d446a752f50819a003167b65da7a"
    sha256 cellar: :any_skip_relocation, ventura:       "c86e862ae79070e79b32984394a8e11e9d77a7920c87b1cc7a83ab9469fdb466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a61f4dfba0bdb890bd4348e871592e175b52f33caf425335b132c21a696f5e47"
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
