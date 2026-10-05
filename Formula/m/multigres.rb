class Multigres < Formula
  desc "Vitess for Postgres"
  homepage "https://multigres.com"
  url "https://github.com/multigres/multigres/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4b083b1342983a1e0c0fdf18d3fe346be511a53609b8238fa1d96d3c5b7807da"
  license "Apache-2.0"
  head "https://github.com/multigres/multigres.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0a895fd36e08e31519c2ee1332c217993b11e5af16a98bc8600a7f68dd9e280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32baf8de899b20a36cc192d49bf5051dbc8bab9eab75b2fa362c08cc7e915876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "396ea84bd1e69894d91678018d9834843cb03eb5ebd4ef509318150e61ea3509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44b1136a655a7034ef29bf35cfa9faeb269838e06cc07f03f28e714725972c1c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    %w[
      multiadmin
      multigateway
      multigres
      multiorch
      multipooler
      pgctld
    ].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/cmd), "./go/cmd/#{cmd}"
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    %w[multigres pgctld multipooler].each do |cmd|
      output, status = Open3.capture2e(bin/cmd, "--not-a-real-option")
      refute_predicate status, :success?
      assert_match "not-a-real-option", output
    end

    # testpath is too long for macOS's 104-byte limit on the generated Unix socket paths.
    config_dir = Pathname(Dir.mktmpdir("mg", "/tmp"))
    begin
      output = shell_output("#{bin}/multigres cluster init --config-path #{config_dir}")
      assert_match "Cluster configuration created successfully", output
      config = (config_dir/"multigres.yaml").read
      assert_match "provisioner: local", config
      assert_match "name: zone1", config
    ensure
      rm_r config_dir
    end
  end
end
