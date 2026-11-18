class Sub2api < Formula
  desc "AI subscription API gateway with an embedded management frontend"
  homepage "https://github.com/Wei-Shaw/sub2api"
  url "https://github.com/Wei-Shaw/sub2api/archive/refs/tags/v0.2.23.tar.gz"
  sha256 "f37649e6e8714b0b05211cca7b249a01b53596428740ae87c26d2ee51214af93"
  license "LGPL-3.0-or-later"
  head "https://github.com/Wei-Shaw/sub2api.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daf07a8b5c2d81c619165a38fdd2fb0a4e765d5ea0bd014dfd5f65d0ec8c9246"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daf07a8b5c2d81c619165a38fdd2fb0a4e765d5ea0bd014dfd5f65d0ec8c9246"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27a09f8300aea8b638c03c41e34c4ece1086260fa87e22d0547603c3eadb7fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94df60c061f1146e7ad0d3d3abb6305919022218c9620f915ff5306dd3c60aa"
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
