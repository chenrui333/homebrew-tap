class Haloy < Formula
  desc "Manage deployments on your own infrastructure"
  homepage "https://haloy.dev/"
  url "https://github.com/haloydev/haloy/archive/refs/tags/v0.1.0-beta.3.tar.gz"
  sha256 "1b1f87113d5771fdb9a9c665127d60cac658d722b834ef54ca490da22a738721"
  license "MIT"
  head "https://github.com/haloydev/haloy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40f161f45ba7a128e2d1c2553ded41c55e39e794ecf8f88353f79f9c9dcc8acc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40f161f45ba7a128e2d1c2553ded41c55e39e794ecf8f88353f79f9c9dcc8acc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40f161f45ba7a128e2d1c2553ded41c55e39e794ecf8f88353f79f9c9dcc8acc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51c14110573c5f561c19905927247ef33b05cb84a607e7856051612edf5f315b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43789ebab34eff1f2eb03c7181eff6253b5604cf4f7a81e6bdd7f010ad2f00d5"
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
