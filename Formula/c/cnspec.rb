class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.10.1.tar.gz"
  sha256 "714ff451c0f433594b1df6f1193db5413bc5d98c2e24358f39d17c1e0e54e0bf"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40f61a88af48f375c21c293e93505b6226b2e39be6802f94e4d665dc1c804acb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fc88247ebe3a13cffbb43a95bb754eace5328ce1297f091bdff87cfcda5aa9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60bf15c3e5bd1f8db406b8963a88595725b8a5e8b02cb8e14f24a3d79e76f754"
    sha256 cellar: :any,                 x86_64_linux:  "08d294a619dca7054291367ebdc7eaf9291281e2f35230c18a5c54b919b2f5d1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec --auto-update=false version")

    output = shell_output("#{bin}/cnspec --auto-update=false policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
