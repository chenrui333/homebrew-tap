class RailsNew < Formula
  desc "Create Rails projects with Ruby installed"
  homepage "https://github.com/rails/rails-new"
  url "https://github.com/rails/rails-new/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "9a309ea0d3f7b7c10327aba30e919bab30efc3bdffc2fcedaa54ce23d9e4ae42"
  license "MIT"
  head "https://github.com/rails/rails-new.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afdd30e8144f0c9fe4ad4f14cf4829ad18a4ade31e82180264dca060eea09b87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "629782b738376ac5cd08464111b69a05fce2dac116ade8c49bed1a7d4a2181f5"
    sha256 cellar: :any_skip_relocation, ventura:       "6d6082c208ac44ee3c2249b4d7124548529823a74c40657de727859d6c9d4dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "261786e81a8927b76dbc092f8b27a30bb854e0460075ab968f7b0eac40b60a5c"
  end

  depends_on "rust" => :build
  depends_on "docker" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/rails-new --version")

    output = shell_output("#{bin}/rails-new testapp 2>&1", 101)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
