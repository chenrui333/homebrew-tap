class Sub2api < Formula
  desc "AI subscription API gateway with an embedded management frontend"
  homepage "https://github.com/Wei-Shaw/sub2api"
  url "https://github.com/Wei-Shaw/sub2api/archive/refs/tags/v0.2.26.tar.gz"
  sha256 "3b8a2461263232877b99c9ebb72839f0b0564f6535792fdffca73d4ba499c956"
  license "LGPL-3.0-or-later"
  head "https://github.com/Wei-Shaw/sub2api.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "454ccea9c1be32867377b3272f639d7daac03b59124c62a004cf676a416084ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e30e56768bb3770100dd68fa13e7352e1b564f82542fe20bafa237ef2e9460f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e30e56768bb3770100dd68fa13e7352e1b564f82542fe20bafa237ef2e9460f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d2ce6773a4e1bfc426db13a2a0ad832f9b9d71df6ecc59f82a23526f868606d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1fe3027aff73623f84b48bf79b8183fef5460ede0fcd9295552917eee99fda"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  deny_network_access!

  def fetch
    require "yaml"

    cd "backend" do
      system "go", "mod", "download"
    end
    cd "frontend" do
      # pnpm 12 reads these unchanged lockfile overrides from workspace config.
      config = JSON.parse(Pathname("package.json").read).fetch("pnpm")
      Pathname("pnpm-workspace.yaml").write config.to_yaml
      system "pnpm", "fetch", "--frozen-lockfile", "--ignore-scripts", "--store-dir", buildpath/"pnpm-store"
    end
  end

  def install
    cd "frontend" do
      system "pnpm", "install", "--offline", "--frozen-lockfile", "--ignore-scripts",
             "--store-dir", buildpath/"pnpm-store"
      system "pnpm", "exec", "vue-tsc", "-b"
      system "pnpm", "exec", "vite", "build", "--outDir", buildpath/"backend/internal/web/dist"
    end
    cd "backend" do
      ENV["CGO_ENABLED"] = "0"
      ldflags = "-X main.Version=#{version} -X main.BuildType=release"
      system "go", "build", *std_go_args(output: libexec/"sub2api", ldflags:), "-tags=embed", "./cmd/server"
      pkgshare.install "resources"
    end
    (bin/"sub2api").write_env_script libexec/"sub2api",
      PRICING_FALLBACK_FILE: pkgshare/"resources/model-pricing/model_prices_and_context_window.json"
    pkgshare.install "deploy/config.example.yaml"
  end

  def caveats
    <<~EOS
      Sub2API requires PostgreSQL and Redis configured by the operator.
      A sample configuration is available at #{pkgshare}/config.example.yaml.
      The service stores its configuration under #{var}/sub2api and runs the
      initial setup frontend until configured. Provider accounts and credentials
      are runtime configuration, not part of installation or tests.
    EOS
  end

  service do
    run [opt_bin/"sub2api"]
    environment_variables DATA_DIR: var/"sub2api", SERVER_HOST: "127.0.0.1"
    working_dir var/"sub2api"
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sub2api --version 2>&1")
    ENV["DATA_DIR"] = testpath.to_s
    ENV["CONFIG_FILE"] = (testpath/"config.yaml").to_s
    (testpath/"config.yaml").write "server: [invalid yaml\n"
    assert_match "read config error", shell_output("#{bin}/sub2api 2>&1", 1)
  end
end
