class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.0.1.tar.gz"
  sha256 "1ab6c0bd271e5fe32ef2d180a25d725379178a8797992dba02978dc65e4aff40"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f766cc691eea3fda7c4abd93c4aa6c57864b1fa43e44c38967d54d8c4705b7fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dee206b8c1422d79aa6b2170040f318edfff6af256781f221979dcb5f8ca5c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9cc1b9ca08278f1b65eb0efcf3f5e68eec02aa5aefe1b573153a2661a9d0c5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0681c8d2f581241a25a5556a785c7a19fe9f2fdfa29cf1f9bdba072f299f840b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aae65ed56efc8e21fb0d9597ebe29ad54239e12fe79b686bc3728dd184d61cf8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
