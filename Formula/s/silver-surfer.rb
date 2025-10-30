class SilverSurfer < Formula
  desc "Kubernetes objects api-version compatibility checker"
  homepage "https://devtron.ai/"
  url "https://github.com/devtron-labs/silver-surfer/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "3ce8a7fe5754078a9d34f7018a0f99cccca37f423a0b9719d3f33570e58130b7"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/silver-surfer --version")
  end
end
