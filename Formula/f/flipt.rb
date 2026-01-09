class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "dbb7a8791ca7964cd9f523a855e838e7d0c8adb7363ad52e7adaa0565d739521"
  # license "FCL-1.0-MIT" # Fair Core License, Version 1.0, MIT Future License
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "695f2c76ade42696d1ade08aae093ba0b7e764e3f86c97fa41de8e0a7351bd47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1de87686cf40293eeb5a011d990cd35acf3e679a239bdc493a27e70b01909fa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "168391f138b172811de2db12cd6d1b15d9db1d4307f1494461a3b73f776a6635"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2acd992bf8666f247b81e77134930642d851962647d94a6a73da20f70b4418b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "904bab0a13a86ab46ad3604ef613f8af177fe8820a1bc59edab29b34a7e08526"
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
