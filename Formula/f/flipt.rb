class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "b5055c61b79c3302e4c37095aa3d2ad901a22366ca8b35f76b65142ac033a81a"
  # license "FCL-1.0-MIT" # Fair Core License, Version 1.0, MIT Future License
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1409862adf05a723d1e0e6b5ad166b29a80073f08dc2683e989f07cc696d488e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8ad8ee26184c45e91e257d49c8493b3b7f56c522609d04997ae0734afc77831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29ca98a02ed85027cfd0a665133642d064ad4b82049245a854427ef896f94a57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "accbda97b03faefb38bdcf107949034840fbb44acb644d4afe8473173478f4d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c586f40f585c7d1f3dc92be6672eb6f70e1cee5bd51ba9f2dbb6dc6890eade"
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
