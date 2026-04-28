class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "556dbbf9f39a0114ddce28280a7b6a0d9130fea58c5e73625ccf39946427688c"
  # license "FCL-1.0-MIT" # Fair Core License, Version 1.0, MIT Future License
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aca0c0e89fd18be3782639f2dca231bbd84418786b455759365a5d0988a8fd7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0804c33c4dcba76f684013e9999b02cbc0bcdc0db23254e1c39ac07f78ad5f1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4765c928c3e708882cda03422c84d70bf950bc2841f7faad274ee6d9175e65f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "127c75bace11c529d693336e348d4fe43bbdd309802d3f5d91a39be3ad01e2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94dacd7bf029877ce3e954d8f9ea337c2b7383e0917b8d84866e3db74ccbaa69"
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
