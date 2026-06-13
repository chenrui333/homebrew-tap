class Snitch < Formula
  desc "SNI-based host discovery tool for TLS layer reconnaissance"
  homepage "https://github.com/cirosec/SNItch"
  url "https://github.com/cirosec/SNItch/archive/refs/tags/v1.3-public.tar.gz"
  sha256 "16374f63e97bb9feb25026087a27f1b444aa254d406bb042f6d4ddd59c739036"
  license "AGPL-3.0-only"
  head "https://github.com/cirosec/SNItch.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}")
  end

  test do
    assert_match "SNItch version #{version}", shell_output("#{bin}/snitch --version")

    output = shell_output(bin/"snitch")
    assert_match "No targets or hosts found.", output
    assert_match "Provide targets as positional argument", output
  end
end
