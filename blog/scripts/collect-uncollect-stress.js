import http from 'k6/http';
import { check } from 'k6';

/**
 * 使用方式:
 * k6 run -e BASE_URL=http://127.0.0.1:8800 -e TOKEN=your_token -e ARTICLE_ID=292 collect-uncollect-stress.js
 */

export const options = {
  scenarios: {
    collect_toggle_200rps: {
      executor: 'constant-arrival-rate',
      rate: 200,
      timeUnit: '1s',
      duration: '60s',
      preAllocatedVUs: 80,
      maxVUs: 300,
    },
  },
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(99)<500'],
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://127.0.0.1:8800';
const TOKEN = __ENV.TOKEN || '';
const ARTICLE_ID = __ENV.ARTICLE_ID || '292';

export default function () {
  const url = `${BASE_URL}/api/article/collect/${ARTICLE_ID}`;
  const headers = TOKEN
    ? { Authorization: TOKEN, 'Content-Type': 'application/json' }
    : { 'Content-Type': 'application/json' };

  const res = http.post(url, null, { headers });

  check(res, {
    'status is 200': (r) => r.status === 200,
    'no frequent-limit error': (r) => !String(r.body || '').includes('请求过于频繁'),
  });
}
