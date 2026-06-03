class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "79d97241d9b74a82e35026cfbf8f12d4a1967f94fac3e332bb2578fbaea555a8"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "771d9c2f1cfb8f343f8f9037de12b586ad074373f37d7dda828011cdc29da7e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "771d9c2f1cfb8f343f8f9037de12b586ad074373f37d7dda828011cdc29da7e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "771d9c2f1cfb8f343f8f9037de12b586ad074373f37d7dda828011cdc29da7e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2567fc2e65b58dc66b791f06110e1a0dc3a0730978aaf20841cbce7101b7cf7c"
    sha256 cellar: :any,                 x86_64_linux:  "3bc0e000630d53d2b45a0bbb937cfc10ab6b16bb9518f97f7a4d939e87c3502a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gpk"
  end

  test do
    assert_match "gpk #{version}", shell_output("#{bin}/gpk --version")
  end
end
