class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "425e3ef1e270cb6254f208305cb8bf891d529441a5b4d527a2bff4315fbc3f11"
  # license "FCL-1.0-MIT" # Fair Core License, Version 1.0, MIT Future License
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "629b4bcdbe61fe380c2f45b6a49f04a464d9c263a2a52065b1f12156cf93f788"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80cc727d5ae784b3d1e734d7b8ef2a0493beaeb011323e78f33379d6b76830a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23801c6b3a5ed6febdf9eb74881eef21c928877086e62111ef671f8cb38da978"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72e9a5354aae6e462f8f00e71659f0f231da178ee589031fedd267b4c940ce41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "676f9c48bc9b5fca90e8f7644714e5d4835aa9f3c27ba00decdb46eec5048583"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/flipt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flipt --version")

    cfg = testpath/"config.yml"
    system bin/"flipt", "config", "init", "--force", "--config", cfg
    assert_match "diagnostics:\n  profiling:\n    enabled: true", cfg.read
  end
end
