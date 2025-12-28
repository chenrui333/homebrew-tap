class Haloy < Formula
  desc "Manage deployments on your own infrastructure"
  homepage "https://haloy.dev/"
  url "https://github.com/haloydev/haloy/archive/refs/tags/v0.1.0-beta.3.tar.gz"
  sha256 "1b1f87113d5771fdb9a9c665127d60cac658d722b834ef54ca490da22a738721"
  license "MIT"
  head "https://github.com/haloydev/haloy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35d0be71c4cc4f9f8e53eb971e235491171f07c3b039f0ddfe6bdf4d98e44bd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35d0be71c4cc4f9f8e53eb971e235491171f07c3b039f0ddfe6bdf4d98e44bd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35d0be71c4cc4f9f8e53eb971e235491171f07c3b039f0ddfe6bdf4d98e44bd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aec143304c5cdbd3d31d5976665e47f751685c7875b3476dd99080dd1d5cce41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "419b90adb218c6c16156ab7eda94c9e9d3459dad95c26fa0545a0075459f7c32"
  end

  depends_on "go" => :build

  def install
    %w[haloy haloyadm].each do |cmd|
      ldflags = "-s -w -X github.com/haloydev/haloy/cmd.version=#{version}"
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"

      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    (testpath/"haloy.yaml").write <<~YAML
      name: "my-app"
      server: haloy.yourserver.com
      domains:
        - domain: "my-app.com"
          aliases:
            - "www.my-app.com"
    YAML

    assert_match "no client configuration found", shell_output("#{bin}/haloy version 2>&1")
    assert_match "Failed to read environment variables", shell_output("#{bin}/haloyadm api token 2>&1", 1)
  end
end
