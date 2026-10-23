class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "d6adfa456fc096874ce16065567c3ae9898061e5bb90ab14e26706dd1f89e3f9"
  # Fair Core License, Version 1.0, with a future MIT license.
  license :cannot_represent
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8888babfa38e71a7b788f01f07558937b4b8857d54b3d9a02302fce7608f8773"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c2353bd7e9c70131eb073e7aceb9679f8e3a5cdf514505b1e1c21aee3410543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32af3d95fb99390110ba67be344aeb97c0c5f046df90ac952a0b71c1ab56b3cc"
    sha256 cellar: :any,                 x86_64_linux:  "7c431a600526e18c2013ac1acf410443c2bd982c88b9dab7ca4ec2a3c6ebd086"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/flipt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flipt --version")

    cfg = testpath/"config.yml"
    system bin/"flipt", "config", "init", "--force", "--config", cfg
    assert_match "storage:\n  default:\n    backend:\n      type: memory", cfg.read
  end
end
