class HindsightControlPlane < Formula
  desc "Web control plane for the Hindsight agent memory server"
  homepage "https://hindsight.vectorize.io"
  url "https://github.com/vectorize-io/hindsight/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "0bddb5599945c757b096a071b7d0b5fd5c5f753bd71f2bcdd435b2d43de81800"
  license all_of: ["MIT", "OFL-1.1"]
  head "https://github.com/vectorize-io/hindsight.git", branch: "main"

  depends_on "node"

  resource "inter" do
    url "https://registry.npmjs.org/@fontsource-variable/inter/-/inter-5.3.0.tgz"
    sha256 "d26710dd38e7217484a1d47ee76c024977ec550548876f26d06ed1844af09a14"
  end

  resource "jetbrains-mono" do
    url "https://registry.npmjs.org/@fontsource-variable/jetbrains-mono/-/jetbrains-mono-5.3.0.tgz"
    sha256 "996fe6368a480c9ce15d4de22a2682b7c40b403718fee2b15e7272f244fd993f"
  end

  # Build tools acquire source dependencies; the test serves a loopback fixture.
  allow_network_access! [:build, :test]

  def install
    ENV["NEXT_TELEMETRY_DISABLED"] = "1"
    fonts = buildpath/"hindsight-control-plane/src/app/[locale]/fonts"
    resources.each do |r|
      r.stage do
        fonts.install "files/#{r.name}-latin-wght-normal.woff2"
        (pkgshare/"fonts"/r.name).install "LICENSE"
      end
    end
    # Keep the upstream typography without next/font/google fetching during compilation.
    inreplace "hindsight-control-plane/src/app/[locale]/layout.tsx" do |s|
      s.gsub! 'import { Inter, JetBrains_Mono } from "next/font/google";', 'import localFont from "next/font/local";'
      s.gsub! "const inter = Inter({\n  subsets: [\"latin\"],\n  weight: [\"400\", \"500\", \"600\", \"700\"],",
              "const inter = localFont({\n  src: \"./fonts/inter-latin-wght-normal.woff2\",\n  weight: \"100 900\","
      s.gsub! "const jetbrainsMono = JetBrains_Mono({\n  subsets: [\"latin\"],\n  weight: [\"400\", \"500\"],",
              "const jetbrainsMono = localFont({\n  src: \"./fonts/jetbrains-mono-latin-wght-normal.woff2\",\n  " \
              "weight: \"100 800\","
    end
    system "npm", "ci", "--ignore-scripts"
    system "npm", "run", "build", "--workspace=@vectorize-io/hindsight-control-plane"
    cd "hindsight-control-plane" do
      inreplace "bin/cli.js", "spawn('node',", "spawn('#{formula_opt_bin("node")}/node',"
      libexec.install "bin", "standalone"
    end
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = %W[sharp-#{os}-#{arch} sharp-libvips-#{os}-#{arch}]
    libexec.glob("standalone/node_modules/@img/sharp-*").each do |dir|
      rm_r(dir) unless native.include?(dir.basename.to_s)
    end
    (bin/"hindsight-control-plane").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/bin/cli.js" "$@"
    SH
    chmod 0755, bin/"hindsight-control-plane"
  end

  def caveats
    <<~EOS
      This is the control-plane UI, not the Hindsight Python API server.
      Configure the separate API with --api-url or HINDSIGHT_CP_DATAPLANE_API_URL.
    EOS
  end

  service do
    run [opt_bin/"hindsight-control-plane", "--hostname", "127.0.0.1"]
    log_path var/"log/hindsight-control-plane.log"
    error_log_path var/"log/hindsight-control-plane.log"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    port = free_port
    pid = spawn bin/"hindsight-control-plane", "--hostname", "127.0.0.1", "--port", port.to_s,
                "--api-url", "http://127.0.0.1:1",
                out: (testpath/"server.log").to_s, err: (testpath/"server.log").to_s
    begin
      sleep 1
      html = shell_output("curl --location --silent --show-error --retry 20 --retry-connrefused --retry-delay 1 " \
                          "http://localhost:#{port}/")
      assert_match "Hindsight", html
      assets = html.scan(%r{/_next/static/[^"\s]+\.css}).uniq
      refute_empty assets
      css = assets.map do |asset|
        shell_output("curl --fail --silent --show-error http://localhost:#{port}#{asset}")
      end.join("\n")
      assert_match "@font-face", css
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
