using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using Kogane;
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace Python4Unity.Sample
{

    public class NumpyExample : MonoBehaviour
	{

        TcpListener server;
        Thread serverThread;
        bool running = false;

        public GameObject License;
        public GameObject MeshbakerChan;

        string basePath;

        void Awake()
        {
            Application.runInBackground = true;
        }

        void Start()
		{

            // サーバー用
            basePath = Application.persistentDataPath;

            // クリップボードを取得
            string clipboard = GUIUtility.systemCopyBuffer;

            // Hyperspace経由かを表す変数
            bool render = false;

			// データ送信を検出した場合Hyperspace経由として記録
			if (clipboard.IndexOf("∞f") != -1)
			{
				render = true;
			}

			if (render == false)
			{
                MeshbakerChan.SetActive(false);
            }

			// Hyperspace経由からの実行だった場合
			if (render == true)
			{

                render = true;

                // ライセンスを非表示
                License.SetActive(false);

                // MeshbakerChanを表示 <3
                MeshbakerChan.SetActive(true);

                using var py = PythonUtil.GetInstance();
                using var seg_comp = PythonUtil.GetInstance();
                using var network = PythonUtil.GetInstance();

				// メッシュベイカーポートを読み込み
				var Meshbaker = py.GetModule("baker_port");
				var SegmentDecompressor = seg_comp.GetModule("decompress");

				// セグメント展開
				string segment_data = SegmentDecompressor.CallAttr<string>(
                    "_decompress",
                    clipboard
                );

                // テンプレート読み込み
                string temp_path = Path.Combine(basePath, "template.xml");
				string template_data = File.ReadAllText(temp_path);

                Debug.Log(segment_data);

                // ベイク結果を取得（Base64）
                string baked = Meshbaker.CallAttr<string>(
					"_bake",
					segment_data,
					template_data
				);

				// ベイク後のパス
				var baked_path = Path.Combine(basePath, "result.mesh.mp3");
				var compressed_seg_path = Path.Combine(basePath, "compressed_segment.xml.gz.mp3");

				// ベイク結果をBase64からバイナリに変換
				byte[] baked_byte = System.Convert.FromBase64String(baked);

				// バイナリを保存
				File.WriteAllBytes(baked_path, baked_byte);

				// セグメントXMLを圧縮
                var compressed_xml = GzipCompressor.Compress(segment_data);

				// セグメントを保存
                File.WriteAllBytes(compressed_seg_path, compressed_xml);

                // サーバーの開始
                StartServer(5000);

                // コルーチンの開始（タイマー）
                StartCoroutine(Save());

            }
		}

        public void StartServer(int port)
        {
            server = new TcpListener(IPAddress.Any, port);
            server.Start();

            running = true;

            serverThread = new Thread(ServerLoop);
            serverThread.Start();

            Debug.Log("HTTP Server started");
        }

        void ServerLoop()
        {
            while (running)
            {
                try
                {
                    var client = server.AcceptTcpClient();
                    HandleClient(client);
                }
                catch (Exception e)
                {
                    Debug.Log(e);
                }
            }
        }

        void HandleClient(TcpClient client)
        {
            using (var stream = client.GetStream())
            using (var reader = new StreamReader(stream))
            {
                string requestLine = reader.ReadLine();

                if (string.IsNullOrEmpty(requestLine))
                    return;

                Debug.Log(requestLine);

                string path = requestLine.Split(' ')[1];

                if (path == "/segment/")
                {
                    SendFile(stream, "compressed_segment.xml.gz.mp3");
                }
                if (path == "/mesh/")
                {
                    SendFile(stream, "result.mesh.mp3");
                }
                if (path == "/test/")
                {
                    SendText(stream, "Running an HTTP server with HyperspaceExporter");
                }
                else
                {
                    Send404(stream);
                }
            }

            client.Close();
        }

        void SendFile(NetworkStream stream, string filename)
        {
            string fullPath = Path.Combine(basePath, filename);

            byte[] data = File.ReadAllBytes(fullPath);

            string header =
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/octet-stream\r\n" +
                "Content-Length: " + data.Length + "\r\n" +
                "Connection: close\r\n\r\n";

            byte[] headerBytes = Encoding.ASCII.GetBytes(header);

            stream.Write(headerBytes, 0, headerBytes.Length);
            stream.Write(data, 0, data.Length);
        }

        void SendText(NetworkStream stream, string text)
        {
            byte[] body = Encoding.UTF8.GetBytes(text);

            string header =
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/plain; charset=utf-8\r\n" +
                "Content-Length: " + body.Length + "\r\n" +
                "Connection: close\r\n\r\n";

            byte[] headerBytes = Encoding.ASCII.GetBytes(header);

            stream.Write(headerBytes, 0, headerBytes.Length);
            stream.Write(body, 0, body.Length);
        }

        void Send404(NetworkStream stream)
        {
            string response =
                "HTTP/1.1 404 Not Found\r\n" +
                "Content-Length: 0\r\n\r\n";

            byte[] bytes = Encoding.ASCII.GetBytes(response);
            stream.Write(bytes, 0, bytes.Length);
        }

        IEnumerator Save()
        {
            yield return new WaitForSeconds(3.32f);

            Application.OpenURL("hyperspacetester://launch");
        }
    }
}