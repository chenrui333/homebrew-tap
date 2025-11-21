class Haloy < Formula
  desc "Manage deployments on your own infrastructure"
  homepage "https://haloy.dev/"
  url "https://github.com/haloydev/haloy/archive/refs/tags/v0.1.0-beta.3.tar.gz"
  sha256 "1b1f87113d5771fdb9a9c665127d60cac658d722b834ef54ca490da22a738721"
  license "MIT"
  head "https://github.com/haloydev/haloy.git", branch: "main"

  depends_on "go" => :build

  def install
    %w[haloy haloyadm].each do |cmd|
      ldflags = "-s -w -X github.com/haloydev/haloy/cmd.version=#{version}"
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"

      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
